local module = {}
export type UILoad = {
    stickPos: Vector2,
    stickRaw: Vector2,
    stickTime: number,
    stickMult: number,
    lockedAxes: {
        x: number,
        y: number
    },
    rot: Vector2,
    orient: {
        yaw: number,
        pitch: number,
        roll: number
    },
    pos: Vector3,
    HUD: Vector3,
    crosshair: Vector3,
    inCamera: boolean,
}

export type Joystick = {
    lockedX: boolean,
    lockedY: boolean,
    enabled: boolean,
    CanEnable: (self: Joystick) -> boolean,
    GetInput: (self: Joystick) -> (Vector2, Vector2),
    Destroy: (self: Joystick) -> ()
}

return module