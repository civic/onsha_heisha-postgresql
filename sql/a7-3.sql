SELECT p.name, MAX(pu.usage) 
FROM process AS p 
LEFT JOIN process_usage AS pu ON p.id = pu.process_id
WHERE p.id > 90
GROUP BY p.name ORDER BY p.name
;

SELECT p.name, pu.max
FROM 
    process AS p,
    LATERAL (SELECT MAX(usage) AS max FROM process_usage WHERE process_id = p.id) AS pu
WHERE p.id > 90
ORDER BY p.name
;

EXPLAIN SELECT p.name, MAX(pu.usage) 
FROM process AS p 
LEFT JOIN process_usage AS pu ON p.id = pu.process_id
WHERE p.id > 90
GROUP BY p.name ORDER BY p.name
;

EXPLAIN SELECT p.name, pu.max
FROM 
    process AS p,
    LATERAL (SELECT MAX(usage) AS max FROM process_usage WHERE process_id = p.id) AS pu
WHERE p.id > 90
ORDER BY p.name
;
