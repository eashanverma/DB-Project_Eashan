DROP VIEW IF EXISTS NEAREST_INDIAN_RESTAURANTS_FROM_UNIVERSITIES_IN_MANCHESTER;
CREATE OR REPLACE VIEW NEAREST_INDIAN_RESTAURANTS_FROM_UNIVERSITIES_IN_MANCHESTER AS
SELECT 
    u.id,
    u.name,
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    ST_DistanceSphere(
        u.geom,  -- No need to transform as we are using ST_DistanceSphere with EPSG:4326
        r.geom   
    ) AS distance_to_restaurant_in_meters,
    ST_MakeLine(
        u.geom,  -- Using original geometries for line visualization
        r.geom   
    ) AS connection_line -- Line geometry for visualization
FROM 
    universities u
JOIN LATERAL (
    SELECT 
        r.*, 
        ST_DistanceSphere(
            u.geom,  
            r.geom   
        ) AS distance
    FROM 
        restaurants r
    ORDER BY 
        ST_DistanceSphere(
            u.geom,  
            r.geom   
        ) ASC
    LIMIT 1
) r ON true
ORDER BY u.id;
