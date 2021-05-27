{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "pragma solidity ^0.5.0;\n",
    "\n",
    "import \"./PupperCoin.sol\";\n",
    "import \"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol\";\n",
    "import \"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol\";\n",
    "import \"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol\";\n",
    "import \"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol\";\n",
    "import \"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol\";\n",
    "\n",
    "/* This crowdsale contract will manage the entire process, allowing users to send ETH and get back PUP (PupperCoin).\n",
    "This contract will mint the tokens automatically and distribute them to buyers in one transaction.\n",
    "*/\n",
    "\n",
    "/* @TODO: Inherit the crowdsale contracts\n",
    "It will need to inherit Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, and MintedCrowdsale.\n",
    "*/\n",
    "contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, \n",
    "RefundablePostDeliveryCrowdsale {\n",
    "\n",
    "    constructor(\n",
    "        // @TODO: Fill in the constructor parameters!\n",
    "        uint rate, // rate in TKNbits\n",
    "        address payable wallet, // sale beneficiary\n",
    "        PupperCoin token, // the PupperCoin token itself that the PupperCoinSale will work with\n",
    "        uint fakenow,\n",
    "        // In the original puppercoinsale, close = now + 24 weeks\n",
    "        // For test purposes only, a) a variable \"fakenow\" is created and b) cloase = fakenow + 1 minutes\n",
    "        uint close,\n",
    "        uint goal\n",
    "    )\n",
    "        Crowdsale(rate, wallet, token)\n",
    "        CappedCrowdsale(goal)\n",
    "        //TimedCrowdsale(open = now, close = now + 1 minutes) in this case\n",
    "        //        TimedCrowdsale(fakenow, fakenow + 1 minutes)\n",
    "        //TimedCrowdsale(open = fakenow, close = fakenow + 24 weeks) in the original question\n",
    "        TimedCrowdsale(now, now + 24 weeks)\n",
    "\n",
    "        RefundableCrowdsale(goal)\n",
    "\n",
    "        // @TODO: Pass the constructor parameters to the crowdsale contracts.\n",
    "        public\n",
    "    {\n",
    "        // constructor can stay empty\n",
    "    }\n",
    "}\n",
    "\n",
    "\n",
    "contract PupperCoinSaleDeployer {\n",
    "\n",
    "    address public pupper_token_address;\n",
    "    address public token_address;\n",
    "\n",
    "    constructor(\n",
    "        // @TODO: Fill in the constructor parameters!\n",
    "        string memory name,\n",
    "        string memory symbol,\n",
    "        address payable wallet, // this address will receive all Ether raised by the sale\n",
    "        uint goal\n",
    "        //create a variable called fakenow\n",
    "        //uint fakenow\n",
    "    )\n",
    "        public\n",
    "    {\n",
    "        // @TODO: create the PupperCoin and keep its address handy\n",
    "        PupperCoin token = new PupperCoin(name, symbol, 0);\n",
    "        token_address = address(token);\n",
    "\n",
    "        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.\n",
    "        //PupperCoinSale pupper_token = new PupperCoinSale(1, wallet, token, goal, fakenow, fakenow + 2 minutes);\n",
    "        PupperCoinSale pupper_token = new PupperCoinSale(\n",
    "                            1, // 1 wei\n",
    "                            wallet, // address collecting the tokens\n",
    "                            token, // token sales\n",
    "                            goal, // maximum supply of tokens \n",
    "                            now, \n",
    "                            now + 24 weeks);\n",
    "        //replace now by fakenow to get a test function\n",
    "\n",
    "        //To test the time functionality for a shorter period of time: use fake now for start time and close time to be 1 min, etc.\n",
    "        //PupperCoinSale pupper_token = new PupperCoinSale(1, wallet, token, goal, fakenow, now + 5 minute);\n",
    "        pupper_token_address = address(pupper_token);\n",
    "\n",
    "        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role\n",
    "        token.addMinter(pupper_token_address);\n",
    "        token.renounceMinter();\n",
    "    }\n",
    "}"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.9"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
