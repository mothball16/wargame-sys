return {
    Instructions = {
        Lockdown = {
            Start = {
                {
                    ID = "LockdownLoop",
                    Looped = true,
                    Delay = 0
                },
                {
                    ID = "LockdownStart",
                    Looped = false,
                    Delay = 0
                }
            },
            End = {
                {
                    ID = "LockdownEnd",
                    Looped = false,
                    Delay = 0
                }
            }
        },
    }
}