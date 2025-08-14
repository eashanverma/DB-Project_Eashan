DROP VIEW IF EXISTS NEAREST_STOPS_FROM_PHARMACY_IN_MANCHESTER;
CREATE OR REPLACE VIEW NEAREST_STOPS_FROM_PHARMACY_IN_MANCHESTER AS
SELECT 
    m.shop_id,
    m.shop_name,
    h.stop_id,
    h.stop_name,
    ST_DistanceSphere(m.location, h.geom) AS distance_to_stop_in_meters, -- Accurate spherical distance in meters
    ST_MakeLine(m.location, h.geom) AS connection_line -- Line geometry for visualization
FROM 
    medical_shops m
JOIN LATERAL (
    SELECT 
        h.*, 
        ST_DistanceSphere(m.location, h.geom) AS distance
    FROM 
        dbproject h
    ORDER BY 
        ST_DistanceSphere(m.location, h.geom) ASC
    LIMIT 1
) h ON true
ORDER BY m.shop_id;
select * from NEAREST_STOPS_FROM_PHARMACY_IN_MANCHESTER;