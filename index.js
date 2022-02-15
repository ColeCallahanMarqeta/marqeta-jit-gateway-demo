const fs = require('fs');
const express = require('express');

const LEDGER_FILE = './ledger.json';
const ledger = require(LEDGER_FILE);

const app = new express();
app.use(express.json());

app.post('/', (req, res) => {
  try {
    const jit_funding = req.body.gpa_order?.jit_funding;
    const merchant_id = req.body.card_acceptor?.mid;
    const user = jit_funding.user_token;

    if (user === 'jit_john' && merchant_id !== 'merchant-01') {
      jit_funding.decline_reason = 'INVALID_MERCHANT'
    } else if (user === 'jit_jane' && jit_funding.amount >= 75) {
      jit_funding.decline_reason = 'AMOUNT_LIMIT_EXCEEDED'
    }

    if (!jit_funding.decline_reason) {
      if (fundsAvailable(user, jit_funding.amount)) {
        updateLedgerBalance(user, jit_funding.amount);
        res.status(200).send({ jit_funding });
        return
      }
      jit_funding.decline_reason = 'INSUFFICIENT_FUNDS';
    }
    res.status(402).send({ jit_funding });
  } catch {
    res.status(500).send({ message: 'Could not process request.' });
    return
  }
})

app.listen(8080, () => console.log('listening on 8080...'));

const fundsAvailable = (user, amount) => {
  try {
    return ledger[user] >= amount;
  } catch {
    return false
  }
}
      
const updateLedgerBalance = (user, amount) => {
  ledger[user] = parseFloat((ledger[user] - amount).toFixed(2));
  fs.writeFileSync(LEDGER_FILE, JSON.stringify(ledger));
}

