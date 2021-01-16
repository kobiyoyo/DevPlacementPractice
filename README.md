# Dev Placement

## Database Schema


## How to Use
```
Docker instructions
```




## API Documentation

## Thought Process

## Requirements

#### Noob
- [x] Can only have a wallet in a single currency selected at signup (main).
- [x] All wallet funding in a different currency should be converted to the main currency.
- [x] All wallet withdrawals in a different currency should be converted to the main currency before transactions are approved.
- [x] All wallet funding has to be approved by an administrator.
- [x] Cannot change main currency.

#### Elite
- [x] Can have multiple wallets in different currencies with a main currency selected at signup.
- [x] Funding in a particular currency should update the wallet with that currency or create it.
- [x] Withdrawals in a currency with funds in the wallet of that currency should reduce the wallet balance for that currency.
- [x] Withdrawals in a currency without a wallet balance should be converted to the main currency and withdrawn.
- [x] Cannot change main currency

#### Admin
- [x] Cannot have a wallet.
- [x] Cannot withdraw funds from any wallet.
- [x] Can fund wallets for Noob or Elite users in any currency.
- [x] Can change the main currency of any user.
- [x] Approves wallet funding for Noob users.
- [x] Can promote or demote Noobs or Elite users


#### Other Requirements
- [x] Write concise api documentation for your endpoints
- [ ] Write tests to cover all scenarios that you implement(I couldnt test service objects,due to time constraints)
- [x] Write a docker-compose file to startup your application and start your db


## Backend
- Ruby on Rails - the web framework used to build the api .
- Rspec - testing framework
- PostgreSQL -  the main reason PostgreSQL is used , in a case where there is a migration failure while modifying your database records , the entire modification gets rolled back to where you started instead of crashing like  MySQL.
- RSpec API Doc Generator - for api documentation
