local merc = select(2, ...)

-- Run all functions that start with Setup
function merc.RunSetupFunctions()
    for k, v in pairs(merc) do
        if string.sub(k, 1, 5) == "Setup" then
            print("Running", k)
            v()
        end
    end
end

merc.RunSetupFunctions()
