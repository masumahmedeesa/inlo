for firebase:
sudo npm install -g firebase-tools
firebase login
firebase init
    -functions
    -existing
    -javascript
    -typescript debug yes
    -yes
cd functions
npm install --save cors
npm install --save @google-cloud/storage
npm install --save firebase-admin

cd ..
firebase deploy
