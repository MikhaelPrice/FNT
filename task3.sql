SELECT
  ml.id AS loan_id,
  IFNULL(mlrs.scheduled_amount, 0) AS scheduled_amount,
  IFNULL(mlt.payed_amount, 0) AS payed_amount,
  IFNULL(mlrs.scheduled_amount, 0) - IFNULL(mlt.payed_amount, 0) AS current_balance
FROM `loan-schema`.m_loan ml
LEFT JOIN (
  SELECT
    loan_id,
    SUM(
      IFNULL(principal_amount, 0)
      + IFNULL(interest_amount, 0)
      + IFNULL(fee_charges_amount, 0)
      + IFNULL(penalty_charges_amount, 0)
    ) AS scheduled_amount
  FROM `loan-schema`.m_loan_repayment_schedule
  WHERE duedate <= CURDATE()
  GROUP BY loan_id
) mlrs ON ml.id = mlrs.loan_id
LEFT JOIN (
  SELECT
    loan_id,
    SUM(IFNULL(amount, 0)) AS payed_amount
  FROM `loan-schema`.m_loan_transaction
  WHERE is_reversed = 0
  GROUP BY loan_id
) mlt ON ml.id = mlt.loan_id
ORDER BY ml.id;