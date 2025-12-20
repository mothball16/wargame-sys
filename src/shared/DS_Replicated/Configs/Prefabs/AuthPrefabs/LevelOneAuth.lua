return {
    Scanner = {
        ScanVisual = "LevelOne",
    },
    AuthChecks = {
        {"OR", {
            {"HasToolWithTag", {"level1"}},
            {"IsOfGroup", {16057783}},
        }},
        {"NotLockdownOrAuth"},
    }
}
