##### Beginning of file

Test.@test( Base.VERSION >= VersionNumber("1.0") )

Test.@test( RemoveLFS.version() > VersionNumber(0) )

Test.@test(
    RemoveLFS.version() ==
        RemoveLFS.version(RemoveLFS)
    )

Test.@test(
    RemoveLFS.version() ==
        RemoveLFS.version(first(methods(RemoveLFS.eval)))
    )

Test.@test(
    RemoveLFS.version() ==
        RemoveLFS.version(RemoveLFS.eval)
    )

Test.@test(
    RemoveLFS.version() ==
        RemoveLFS.version(RemoveLFS.eval, (Any,))
    )

Test.@test( RemoveLFS.version(TestModuleA) == VersionNumber("1.2.3") )

Test.@test( RemoveLFS.version(TestModuleB) == VersionNumber("4.5.6") )

Test.@test_throws(
    ErrorException,
    RemoveLFS._TomlFile(joinpath(mktempdir(),"1","2","3","4")),
    )

##### End of file

