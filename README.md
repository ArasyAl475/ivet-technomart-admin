🚀 Deployment
  #### Firebase Web Hosting
  - Initialize Hosting
    If you haven’t already:
    ```shell
     firebase init hosting
    ```

  - Build project:
   ```shell
     flutter clean 
   ```
   ```shell
     flutter build web --release --no-tree-shake-icons
   ```
  - Deploy Hosting on Default Hosting Domain:
   ```shell
     firebase deploy --only hosting
   ```
  - Deploy Hosting on your Custom Domain:
  - `firebase deploy --only hosting:YOUR_HOSTING_NAME`
  ```shell
   firebase deploy --only hosting:tstore-admin
  ```


* Copyright (C) 2025 Coding with T.
* Licensed under Professional Tier (PID: #{your_license_id OR your_order_id}).
* Unauthorized use violates EULA (End User License Agreement) and may result in legal action.


