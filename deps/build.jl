using BinaryProvider

download_info = Dict(
    "CORE_BUNDLE_URL" => ("https://github.com/bmharsha/PlotlyJS.jl/releases/download/v0.12.90/plotly-latest.min.js", "49931a0d14ec3f33e91739836539bc9c6f218024f2dd786349b0b38b3cad436510dc0431dcde4c445fa80ff0ff85b06f74effda3df9932184131d32302cce51d"),
    "GENERIC_HTTP_BUNDLE_URL" => ("https://github.com/bmharsha/PlotlyJS.jl/releases/download/v0.12.90/plotschema.json", "f9fd4d2fbd4bcb2bc7b5ef540f6115d3d2dc9859715c60030a68fe37b4ca5204c8e76eb3bad643ff501f3940d9ffc357ef044bed7a3e0a880a51"),
)

const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_deps = joinpath(_pkg_root,"deps")
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

function datadown(thepath, thefile, theurl)
    filepath = joinpath(thepath, thefile)
    try
        BinaryProvider.download(theurl, filepath)
    catch 
        if isfile(filepath)
            @warn("Failed to update $thefile, but you already have it. Things might continue to work, but if you would like to make sure you have the latest version of $thefile, use may use your web-browser to download it from $theurl and place it in $_pkg_deps.")
        else
            error("Failed to download $thefile from $theurl. You may use your web-browser to download it from $theurl and place it in $_pkg_deps.")
        end
    end
end

URL = ENV["JULIA_PKG_SERVER"] * "/binary/PlotlyJS.jl/v0.12.90/plotschema.json"
datadown(_pkg_deps, "plotschema.json", URL)
URL = ENV["JULIA_PKG_SERVER"] * "/binary/PlotlyJS.jl/v0.12.90/plotly-latest.min.js"
datadown(_pkg_assets, "plotly-latest.min.js", URL)

include("make_schema_docs.jl")
include("find_attr_groups.jl")
AttrGroups.main()
