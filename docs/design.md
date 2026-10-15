# Design Notes

Why the parts look the way they do, and what the design does not cover. Z positions are measured from the base floor and exclude the 2 mm pads.

## Load path

The dryer's feet stand inside the rim on the top. Seats in the top's underside are clamped to the free ends of the two cells; the cable ends of the cells are clamped to two pedestals in the base. That is the only connection between the two parts.

Because the dryer is tall and holds two spools, the top is carried on two cells instead of one. Each cell behaves like the single cell of the smaller scale, but the pair spreads the load over a 120 mm span, so the top rocks far less and an off-centre load still sums correctly: the vertical forces on the two cells always add up to the weight. The two raw counts are added before filtering, so the electronics, the stability gate and the calibration see one number.

Each load tips its pedestal towards that cell's free end: its front edge presses down and its rear screw pulls up with about three times the load each, 19 mm apart. Two solid rails run beside each cell from behind the pedestal to the far end wall and spread that couple over 140 mm. Nothing stands under the cells, which have to bend freely.

## Clearances

| Clearance | Nominal |
|---|---:|
| Top above the base wall (the visible gap) | 3.5 mm |
| Top's underside inside the base walls | 4 mm |
| Top's underside above the base rails | 4 mm |
| Top's underside above the board caps | 6.9 mm |
| Cells above the base floor | 2.3 mm, 1.3 mm at the potting |
| Channel roof above the fixed-end screw tips | 4.2 mm |

Assertions in [`cad/scale.scad`](../cad/scale.scad) fail the export if a parameter change breaks one of these.

## Fastening

The cells' M4 and M5 threads are larger than M3, so every screw passes through a cell and clamps it with a nut.

- **Fixed ends** — heads in counterbores under the base, 3.7 mm of printed seat, the cell, then washer and nut. The seat is as thick as a 20 mm screw allows, which leaves the heads 0.4 mm proud of the floor, inside the height of the pads.
- **Moving ends** — head and washer under each cell, through the cell and 3.6 mm of solid seat into a nut at the bottom of a hex well open to the top face. The nut has to sit above the seat: a nut between seat and cell would be drawn onto the cell and leave the top loose.

The screws have about 1 mm of play in the cell's holes. Lips on each pedestal form a 13 mm slot that sets the cell's angle; the top's seats are flat and squared by eye before tightening.

## Stiffness

The top is carried from two 24 mm seats 120 mm apart and cantilevers about 85 mm past each. It is a 7.5 mm plate on a solid underside 5.5 mm deep that hangs inside the base and ends level with the top of the cells, with a channel over each cell. At this depth a solid section is the stiffest option: ribs would sag about twice as much.

The cantilever is shorter than on the single-cell scale, so the deck sags less for the same depth. Sag does not change the reading, since all weight still passes through the cells.

## Dimensions

| Feature | Position |
|---|---|
| Base | 251 × 200 mm footing, Z 0–4; 251 × 172 mm shell with 1.6 mm walls to Z 21 |
| Pedestals | X −40 to −16, at Y ±60; top at Z 6.3, lips to Z 7.3 |
| Rails | 6 mm wide beside each cell; Z 15 at the pedestal, tapering to Z 8 at the far wall |
| Cells | Z 6.3–19, screws at X ±20 and ±35, Y ±60 |
| Board pockets | Boards at Z 5, walls to Z 10.5, caps to Z 12.1 |
| USB notch | X −103 to −87 in the rear wall, above Z 4.5 |
| Top | Plate Z 24.5–32, rim to Z 35, underside 239.8 × 160.8 mm down to Z 19 |
| Pads | X ±110.5, Y ±85 |

The caps limit how far a board can lift (0.5 to 1.7 mm) instead of clamping it, so they tolerate parts of different height. Each leg is 1 mm thick and bends 0.55 mm over a 0.7 mm ridge, about 3% strain.

## Limits

- **No overload stops.** The top would have to close the full 3.5 mm gap before the base catches it, far beyond the roughly 150% a 5 kg cell survives, so keep the total load below 4.5 kg, which the firmware also enforces at capture.
- **Off-centre load.** The two cells sum correctly, but a bar cell's rating says nothing about corner accuracy; the checks in the [Build Guide](build.md#7-verify) measure it.
- **Two-spool capture.** The estimate is the total in the dryer, so removing one spool to print with reads as that spool being consumed; capture again after swapping one spool.
- **Heat.** The electronics sit in the same enclosure as the cells, under a dryer. The gap, the floor openings and the USB notch let air through, but the cells' temperature under a long drying cycle has not been measured.
- **Creep.** Printed seats relax under clamp force and warmth. Long-term drift has not been quantified.
- **Tipping.** The SH02 is 283.5 mm tall and top-heavy. The base is 28 mm wider and 0 mm longer than the top, and the pads sit outside the dryer's feet, but a tall dryer still tips more easily than a flat one.
- **Not sealed.** The enclosure is open to dust and spills.
