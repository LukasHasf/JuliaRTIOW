
module RayTracingInOneWeekend
using Images
using ProgressMeter
include("vectors.jl")
include("rays.jl")
include("hittable.jl")
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

function ray_color(r::Ray, world, depth)
    rec = HitRecord()
    if depth < 0
        return Color3(0,0,0)
    end
    for obj in world
        t = hit!(r, obj, 0.001, Inf, rec)
        if t
            target = rec.p + rec.normal + random_unit_vector()
            return 0.5 * ray_color(Ray(rec.p, target - rec.p), world, depth-1)
        end
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
    scene = [Sphere(Point3(0,0,-1), 0.5), Sphere(Point3(0, -100.5,-1), 100)]

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
