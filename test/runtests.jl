using ProductizeBayes, Test

TestDir = @__DIR__

test_versioned = [
    "test_versioned_model/test_versioned_model.jl"
  ]

  @testset "VersionedModel basic tests" begin
    for test in test_versioned
      println("\nTesting: $test.")
      include(joinpath(TestDir, test))
    end
    println()
  end
