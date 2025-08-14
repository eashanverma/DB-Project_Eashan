DROP VIEW IF EXISTS NEAREST_STOPS_FROM_UNIVERSITIES_IN_MANCHESTER;
CREATE OR REPLACE VIEW NEAREST_STOPS_FROM_UNIVERSITIES_IN_MANCHESTER AS
SELECT 
    u.id,
    u.name,
    h.stop_id,
    h.stop_name,
    ST_DistanceSphere(
        u.geom,  -- No need to transform if using ST_DistanceSphere with EPSG:4326
        h.geom   
    ) AS distance_to_stop_in_meters,
    ST_MakeLine(
        u.geom,  -- Using original geometries for line visualization
        h.geom   
    ) AS connection_line  -- Line geometry for visualization
FROM 
    universities u
JOIN LATERAL (
    SELECT 
        h.*, 
        ST_DistanceSphere(
            u.geom,  
            h.geom   
        ) AS distance
    FROM 
        dbproject h
    ORDER BY 
        ST_DistanceSphere(
            u.geom,  
            h.geom   
        ) ASC
    LIMIT 1
) h ON true
ORDER BY u.id;