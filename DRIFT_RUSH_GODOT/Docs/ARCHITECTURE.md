# Architecture
Race.tscn loads Race.gd, which creates genuine MeshInstance3D geometry, static guardrails/ground, CharacterBody3D kart, Camera3D and CanvasLayer controls. Physics runs at engine physics ticks. Further work should extract input, vehicle, lap and UI systems before networking. Firebase should manage identity/room metadata; authoritative ENet server should manage race simulation.
