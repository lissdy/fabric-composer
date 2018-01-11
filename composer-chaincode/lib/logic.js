'use strict';

/**
 * Sample transaction
 * @param {org.lisa.hyperledger.Trade} trade
 * @transaction
 */
 function tradeCommodity(trade) {
     trade.commodity.owner = trade.newOwner;
     return getAssetRegistry('org.acme.biznet.Commodity')
         .then(function (assetRegistry) {
             return assetRegistry.update(trade.commodity);
         });
 }
