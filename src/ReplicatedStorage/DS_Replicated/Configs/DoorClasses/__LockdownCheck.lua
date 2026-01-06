-- centralized lockdown logic
-- this should b placed in every Auth class unless there is an explicit reason not to

return {"OR", {
    {"NotLockdownOrAuth"}
}}