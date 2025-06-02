SELECT
    vmk.id AS make_id,
    vmk.name AS make_name,
    COUNT(ml.id) AS num_vehicles_sold
FROM
    `asset-schema`.vehicle_make vmk
LEFT JOIN `asset-schema`.vehicle_model vml
    ON vmk.id = vml.vehicle_make_id
LEFT JOIN `asset-schema`.asset a
    ON vml.id = a.model_id
LEFT JOIN `loan-schema`.m_loan ml
    ON a.m_loan_id = ml.id
    AND ml.disbursedon_date >= '2020-01-01'
    AND ml.disbursedon_date < '2020-03-01'
GROUP BY
    vmk.id, vmk.name
ORDER BY
    num_vehicles_sold DESC;
