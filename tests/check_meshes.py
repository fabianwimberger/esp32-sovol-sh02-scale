"""Check that each exported STL is one closed solid of the expected size."""

import logging
from collections import Counter, defaultdict
from pathlib import Path

LOG = logging.getLogger(__name__)


def check_mesh(path: Path) -> None:
    vertices = []
    for line in path.read_text().splitlines():
        fields = line.split()
        if fields and fields[0] == "vertex":
            vertices.append(tuple(round(float(value), 5) for value in fields[1:]))
    assert vertices and len(vertices) % 3 == 0, path
    edges = Counter()
    neighbors = defaultdict(set)
    volume = 0.0
    for i in range(0, len(vertices), 3):
        a, b, c = vertices[i : i + 3]
        assert len({a, b, c}) == 3, (path, "degenerate triangle")
        for start, end in ((a, b), (b, c), (c, a)):
            edges[start, end] += 1
            neighbors[start].add(end)
            neighbors[end].add(start)
        volume += (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) / 6
    assert all(
        count == 1 and edges[end, start] == 1 for (start, end), count in edges.items()
    ), (path, "open or non-manifold edge")
    visited = set()
    pending = [vertices[0]]
    while pending:
        vertex = pending.pop()
        if vertex not in visited:
            visited.add(vertex)
            pending.extend(neighbors[vertex] - visited)
    assert len(visited) == len(neighbors), (path, "disconnected bodies")
    assert volume > 0, (path, "inverted or empty solid")
    bounds = [
        (min(v[i] for v in vertices), max(v[i] for v in vertices)) for i in range(3)
    ]
    dimensions = [high - low for low, high in bounds]
    expected = {
        "base": (251, 200),
        "deck": (251, 172),
        "esp32_cap": (25.05, 24.55),
        "hx711_cap": (28.36, 25.35),
    }[path.stem]
    assert all(abs(d - e) < 0.01 for d, e in zip(dimensions, expected)), (
        path,
        dimensions,
    )
    assert abs(bounds[2][0]) < 0.001, (path, "not on print plane")
    LOG.info("%s: closed single solid, %.2f × %.2f × %.2f mm", path.name, *dimensions)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    paths = sorted((Path(__file__).resolve().parents[1] / "printable").glob("*.stl"))
    assert {path.stem for path in paths} == {"base", "deck", "esp32_cap", "hx711_cap"}
    for mesh in paths:
        check_mesh(mesh)
