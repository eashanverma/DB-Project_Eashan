DROP VIEW IF EXISTS NEAREST_PHARMACY_FROM_UNIVERSITIES_IN_MANCHESTER;

CREATE OR REPLACE VIEW NEAREST_PHARMACY_FROM_UNIVERSITIES_IN_MANCHESTER AS
SELECT 
    u.id,
    u.name,
    m.shop_name,
    m.address,
    m.city,
    m.phone_number,
    ST_DistanceSphere(
        u.geom,  -- No need to transform as we are using ST_DistanceSphere with EPSG:4326
        m.location  
    ) AS distance_to_stop_in_meters,
    ST_MakeLine(
        u.geom,  -- Using original geometries for line visualization
        m.location  
    ) AS connection_line  -- Line geometry for visualization
FROM 
    universities u
JOIN LATERAL (
    SELECT 
        m.*, 
        ST_DistanceSphere(
            u.geom,  -- No need to transform as we are using ST_DistanceSphere with EPSG:4326
            m.location  
        ) AS distance
    FROM 
        medical_shops m
    ORDER BY 
        ST_DistanceSphere(
            u.geom,  -- No need to transform as we are using ST_DistanceSphere with EPSG:4326
            m.location  
        ) ASC
    LIMIT 1
) m ON true
ORDER BY u.id;