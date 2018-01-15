'use strict';

/**
 * Track the trade of a commodity from one trader to another
 * @param {org.lisa.hyperledger.Trade} trade
 * @transaction
 */
 function tradeCommodity(trade) {
     trade.commodity.owner = trade.newOwner;
     return getAssetRegistry('org.lisa.hyperledger.Commodity')
         .then(function (assetRegistry) {
             return assetRegistry.update(trade.commodity);
         });
 }
