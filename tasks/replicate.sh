curl http://admin:admin@localhost:5984/_replicate -H 'Content-Type: application/json' -d '{ "source": "https://@aptos.cloudant.com/shepherd_production" , "target": "http://localhost:5984/shepherd_backup" }'