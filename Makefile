# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: test

# deps
install:; forge install
update:; forge update

# Build & test
build  :; forge build
test   :; forge test --fork-url https://eth-goerli.g.alchemy.com/v2/$(ALCHEMY_API_KEY)
trace   :; forge test --fork-url https://eth-goerli.g.alchemy.com/v2/$(ALCHEMY_API_KEY) -vvvv
coverage   :; forge coverage --fork-url https://eth-goerli.g.alchemy.com/v2/$(ALCHEMY_API_KEY) -vvvv
clean  :; forge clean
snapshot :; forge snapshot
fmt    :; forge fm