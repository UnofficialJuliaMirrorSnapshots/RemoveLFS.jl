##### Beginning of file

Test.@test( isdir(RemoveLFS.package_directory()) )

Test.@test( isdir(RemoveLFS.package_directory("ci")) )

Test.@test( isdir(RemoveLFS.package_directory("ci", "travis")) )

Test.@test( isdir(RemoveLFS.package_directory(TestModuleA)) )

Test.@test( isdir(RemoveLFS.package_directory(TestModuleB)) )

Test.@test(
    isdir( RemoveLFS.package_directory(TestModuleB, "directory2",) )
    )

Test.@test(
    isdir(
        RemoveLFS.package_directory(
            TestModuleB, "directory2", "directory3",
            )
        )
    )

Test.@test_throws(
    ErrorException,RemoveLFS.package_directory(TestModuleC),
    )

##### End of file

