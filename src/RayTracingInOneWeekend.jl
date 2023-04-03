
module RayTracingInOneWeekend
using Images
using ProgressMeter
include("vectors.jl")
include("rays.jl")
include("material.jl")
include("sphere.jl")
include("camera.jl")

"""    ray_color(r::Ray)

Return the color of the void.
"""
function ray_color(r::Ray)
    unit_dir = unit_vector(r.direction)
    t = 0.5 * (unit_dir[2] + 1)
    primary = Color3(1, 1, 1)
    secondary = Color3(0.5, 0.7, 1.0)
    return (1-t)*primary + t*secondary
end

function closest_hit(r::Ray, t_min, t_max, rec, world)
    temp_rec = HitRecord()
    hit_anything = false
    closest_so_far = t_max
    for obj in world
        if hit!(r, obj, t_min, closest_so_far, temp_rec)
            hit_anything = true
            closest_so_far = temp_rec.t
            replicate!(rec, temp_rec)
        end
    end
    return hit_anything
end

function ray_color(r::Ray, world, depth)
    rec = HitRecord()
    if depth < 0
        return Color3(0,0,0)
    end
    if closest_hit(r, 0.001, Inf, rec, world)
        hit, scattered, attenuation = scatter!(r, rec, rec.material)
        if hit
            return attenuation * ray_color(scattered, world, depth-1)
        end
        return Color3(0,0,0)
    end
    return ray_color(r)
end

function write_color!(arr, i, j, color, nsamples)
    r, g, b = color[:] ./ nsamples
    arr[i,j, 1] = r
    arr[i,j, 2] = g
    arr[i,j, 3] = b
end

function save_img(path, arr)
    # Gamma transform
    arr = arr .^ 0.5
    save(path, colorview(RGB, [arr[:, :, i] for i in 1:3]...))
end

function main()
    # Image
    aspect_ratio = 16/9
    img_width = 400
    img_height = trunc(Int, img_width/aspect_ratio)
    img = zeros(img_height, img_width, 3)
    nsamples = 100
    max_depth = 50

    # Camera
    cam = Camera()

    # World
    material_ground = Lambertian(0.8, 0.8, 0)
    material_center = Lambertian(0.1, 0.2, 0.5)
    material_left = Dielectric(1.5)
    material_right = Metal(0.8, 0.6, 0.2, 0.0)
    scene = []
    push!(scene, Sphere(Point3(0, -100.5,-1), 100, material_ground))
    push!(scene, Sphere(Point3(0, 0, -1), 0.5, material_center))
    push!(scene, Sphere(Point3(-1, 0, -1), 0.5, material_left))
    push!(scene, Sphere(Point3(-1, 0, -1), -0.4, material_left))
    push!(scene, Sphere(Point3(1, 0, -1), 0.5, material_right))

    # Rendering
    @showprogress "Rendering..." for i in 1:img_height
        for j in 1:img_width
            pixel_color = Color3(0, 0, 0)
            for n in 1:nsamples
                u = (j + rand())/img_width
                v = (img_height-i+rand())/img_height
                r = get_ray(cam, u, v)
                pixel_color += ray_color(r, scene, max_depth)
            end
            write_color!(img, i, j, pixel_color, nsamples)
        end
        save_img("render.png", img)
    end
end

end # module RayTracingInOneWeekend
