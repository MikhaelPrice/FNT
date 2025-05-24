SELECT
  mlrs.loan_id,
  mlrs.duedate,
  mlrs.principal_amount + mlrs.interest_amount AS weekly_payment
FROM `loan-schema`.m_loan_repayment_schedule mlrs
WHERE mlrs.completed_derived = 0
  AND mlrs.duedate = (
      SELECT MIN(mlrsMin.duedate)
      FROM `loan-schema`.m_loan_repayment_schedule mlrsMin
      WHERE mlrsMin.loan_id = mlrs.loan_id AND mlrsMin.completed_derived = 0
  );