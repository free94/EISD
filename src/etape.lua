etape = dark.pipeline()
--[[
etape:pattern("[&etape &ADV? &VRB .*? /^[%.;%!]+$/ ]")
]]

etape:pattern("[&etape /^%u/ .*? /^[%.;%!]+$/ ]")