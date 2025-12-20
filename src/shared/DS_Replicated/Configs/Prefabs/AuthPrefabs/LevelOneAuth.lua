return {
    Scanner = {
        ScanVisual = "LevelOne",
        UseThrottle = 1,
    },
    AuthChecks = {
        {"OR", {
            {"HasToolWithTag", {"level1"}},
            {"IsOfGroup", {16057783}},
        }},
        {"NotLockdownOrAuth"},
    }
}
