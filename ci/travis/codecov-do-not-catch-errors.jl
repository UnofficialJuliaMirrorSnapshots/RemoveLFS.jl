import Pkg

try
    Pkg.add("Coverage")
catch e1
    @warn(
        string("Ignoring exception e1:"),
        e1,
        )
end

import Coverage

import RemoveLFS

cd(RemoveLFS.package_directory())

Coverage.Codecov.submit(Coverage.Codecov.process_folder())
