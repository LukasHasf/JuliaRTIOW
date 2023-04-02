

@testset "Vec3 constructor" begin
    v = Vec3(6,3,2)
    @test v.x == 6
    @test v.y == 3
    @test v.z == 2
    @test Vec3(6,3,2)==Vec3(6,3,2)
    @test Vec3(6,3,1)!=Vec3(6,3,2)
    @test Vec3() == Vec3(0,0,0)
    v = random_vec()
    @test all([0 < v[i] < 1 for i in 1:3])
    v = random_vec(1, 10)
    @test all([1 < v[i] < 10 for i in 1:3])
end

@testset "Norms" begin
    v = Vec3(1,2,3)
    @test norm_squared(v) == 14
    @test norm(v) == sqrt(14)
    v = Vec3(-1, 2, 3)
    @test norm_squared(v) == 14
    @test norm(v) == sqrt(14)
end

@testset "Dot and cross" begin
    v = random_vec(-1, 1)
    @test norm_squared(v) == dot(v, v)
    w = random_vec(-1, 1)
    @test dot(v, w) == v.x * w.x + v.y * w.y + v.z * w.z
    @test cross(v, v) == Vec3(0,0,0)
end