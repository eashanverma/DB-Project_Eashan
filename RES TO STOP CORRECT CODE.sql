DROP VIEW IF EXISTS NEAREST_STOPS_FROM_RESTAURANTS_IN_MANCHESTER;
CREATE OR REPLACE VIEW NEAREST_STOPS_FROM_RESTAURANTS_IN_MANCHESTER AS
SELECT 
    r.id,
    r.name,
    r.address,
    h.stop_id,
    h.stop_name,
    ST_DistanceSphere(r.geom, h.geom) AS distance_to_stop_in_meters, -- Accurate spherical distance in meters
    ST_MakeLine(r.geom, h.geom) AS connection_line -- Line geometry for visualization
FROM 
    restaurants r
JOIN LATERAL (
    SELECT 
        h.*, 
        ST_DistanceSphere(r.geom, h.geom) AS distance
    FROM 
        dbproject h
    ORDER BY 
        ST_DistanceSphere(r.geom, h.geom) ASC
    LIMIT 1
) h ON true
ORDER BY r.id;
