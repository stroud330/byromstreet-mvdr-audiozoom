function inside = pointInPolygon(x, y, vertices)
    inside = inpolygon(x, y, vertices(:, 1), vertices(:, 2));
end
