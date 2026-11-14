# PB FakeCheat — UI-only anti-cheat test panel

This repository contains a **visual test panel only**. It creates a local GUI and
prints simulated telemetry to the client output. It does not automate shots,
steals, blocks, movement, stamina, farming, or interfere with network traffic.

## Files
- `loader.lua` — GitHub raw loader.
- `main.lua` — GUI and local event log.
- `tabs/*.lua` — tab definitions.

## Setup
1. Create a public GitHub repository named `PB-FakeCheat`.
2. Upload these files, preserving the folder structure.
3. Replace `YOUR_USERNAME` in `loader.lua` with your GitHub username.
4. Run the loader only in an environment you control and are authorized to test.

The loader uses `game:HttpGet` and `loadstring`, which are executor-style APIs and
are not available to ordinary Roblox LocalScripts. For Roblox Studio, place
`main.lua` in a LocalScript under `StarterPlayerScripts` and adapt the module
loading to your Studio project.

## Test events
Toggle controls create local, clearly labeled simulated events. To connect the
test panel to an anti-cheat you own, replace the `record_event` function with
your own test adapter. Do not trust client-reported telemetry for enforcement;
server-side validation must make the decision.
