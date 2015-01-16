etape = dark.pipeline()
--[[
etape:pattern("[&etape &ADV? &VRB .*? /^[%.;%!]+$/ ]")
]]

etape:pattern("[&etape /^%u/ .*? /^[%.;%!]+$/ ]")
etape:pattern("[&chrono [&encours &etape][&ensuite &etape]]")
etape:pattern("[&chrono [&encours &ensuite][&ensuite &etape]]")