"""Render docs/assembled.jpg from the exported STL files."""

from pathlib import Path

import bpy
from mathutils import Vector

ROOT = Path(__file__).resolve().parents[1]


def material(
    name: str, color: tuple[float, float, float], roughness: float = 0.7
) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    shader = mat.node_tree.nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = (*color, 1)
    shader.inputs["Roughness"].default_value = roughness
    return mat


def mesh(
    name: str, location: tuple[float, float, float], mat: bpy.types.Material
) -> None:
    bpy.ops.wm.stl_import(
        filepath=str(ROOT / "printable" / f"{name}.stl"), global_scale=0.001
    )
    obj = bpy.context.object
    obj.name = name
    obj.location = Vector(location) / 1000
    obj.data.materials.clear()
    obj.data.materials.append(mat)


def aim(obj: bpy.types.Object, target: tuple[float, float, float]) -> None:
    obj.rotation_euler = (
        (Vector(target) - obj.location).to_track_quat("-Z", "Y").to_euler()
    )


def light(
    name: str, location: tuple[float, float, float], power: float, size: float
) -> None:
    data = bpy.data.lights.new(name, "AREA")
    data.energy = power
    data.shape = "DISK"
    data.size = size
    obj = bpy.data.objects.new(name, data)
    bpy.context.collection.objects.link(obj)
    obj.location = location
    aim(obj, (0, 0, 0.01))


def box(
    center: tuple[float, float, float],
    size: tuple[float, float, float],
    mat: bpy.types.Material,
) -> None:
    bpy.ops.mesh.primitive_cube_add(size=1, location=Vector(center) / 1000)
    obj = bpy.context.object
    obj.dimensions = Vector(size) / 1000
    obj.data.materials.append(mat)


if __name__ == "__main__":
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    shell = material("Charcoal polymer", (0.055, 0.061, 0.067))
    top = material("Graphite polymer", (0.078, 0.085, 0.092))
    rubber = material("Rubber", (0.015, 0.015, 0.015), 0.9)
    board = material("PCB", (0.09, 0.30, 0.15))
    connector = material("USB-C shell", (0.62, 0.63, 0.65), 0.4)
    mesh("base", (0, 0, 0), shell)
    mesh("deck", (0, 0, 19), top)
    for x in (-110.5, 110.5):
        for y in (-85, 85):
            bpy.ops.mesh.primitive_cylinder_add(
                vertices=48,
                radius=0.006,
                depth=0.002,
                location=(x / 1000, y / 1000, -0.001),
            )
            bpy.context.object.data.materials.append(rubber)
    for x in (-65, 65):
        box((x, 0, 12.65), (12.7, 80, 12.7), rubber)
    for y in (-25, 25):
        box((-30, y, 6.61), (21.06, 34.35, 3.22), rubber)
    box((-30, 71.275, 5.835), (17.75, 22.75, 1.67), board)
    box((-30, 80.525, 8.245), (8.5, 7.75, 3.15), connector)
    bpy.ops.mesh.primitive_plane_add(size=400, location=(0, 0, -0.0021))
    bpy.context.object.data.materials.append(material("Backdrop", (0.68, 0.70, 0.72)))
    light("Key", (-0.15, -0.18, 0.3), 1.2, 0.23)
    light("Fill", (0.18, -0.02, 0.20), 0.5, 0.2)
    light("Rim", (0, 0.20, 0.25), 0.9, 0.18)
    camera_data = bpy.data.cameras.new("Camera")
    camera = bpy.data.objects.new("Camera", camera_data)
    bpy.context.collection.objects.link(camera)
    camera.location = (0.20, -0.36, 0.20)
    aim(camera, (0, 0, 0.013))
    camera_data.type = "ORTHO"
    camera_data.ortho_scale = 0.34
    scene = bpy.context.scene
    scene.camera = camera
    scene.render.engine = "CYCLES"
    scene.cycles.samples = 48
    scene.cycles.use_denoising = True
    scene.render.threads_mode = "FIXED"
    scene.render.threads = 4
    scene.world.color = (0.3, 0.3, 0.3)
    scene.render.resolution_x = 1200
    scene.render.resolution_y = 800
    scene.render.resolution_percentage = 100
    # Blender writes every enabled stamp field into the file's metadata.
    for name in dir(scene.render):
        if name.startswith("use_stamp"):
            setattr(scene.render, name, False)
    scene.render.image_settings.file_format = "JPEG"
    scene.render.image_settings.quality = 90
    scene.render.filepath = str(ROOT / "docs" / "assembled.jpg")
    bpy.ops.render.render(write_still=True)
