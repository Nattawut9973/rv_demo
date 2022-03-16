# sb7-demo-acc

backup restore system for demo account on rvwizard.com

## ขั้นตอนการใช้งาน:

- สร้าง cpanel user

- ติดตั้ง Rvsitebuilder7

- เลือก template และแก้ไข content ที่ต้องการนำเสนอ

- จากนั้นเปิด terminal ไปที่เครื่อง server1.rvwizard.com(หรือเครื่องที่มี cpanel user) ด้วยสิทธิ์ root.

### มีคำสั้งหลักๆ4ข้อ ดังนี้

1. Register  
    * คือการจัดเก็บข้อมูลต่างๆของ cpanel user เพื่อใช้สำหรับการ restore

      ```language
        perl /usr/local/rv_demo_acct_manage/demo_acct_manage.pl regisaccount {CPANELUSER}
      ```

2. Restore
    * แบ่งเป็นการ restore ทีละ user และ restore ทั้งหมด
      - restore 1 user

      ```language
        perl /usr/local/rv_demo_acct_manage/demo_acct_manage.pl restoreaccount {CPANELUSER}
      ```

      - restore ทั้งหมด

       ```language
        perl /usr/local/rv_demo_acct_manage/demo_acct_manage.pl restoreaccount  
       ```

        หรือ

       ```language
        perl /usr/local/rv_demo_acct_manage/demo_acct_manage.pl restoreaccount all
       ```

        >ทุกๆเที่ยงวันตามเวลาประเทศไทย(12.00น.) Cron จะรันscript "/usr/local/rv_demo_acct_manage/demo_acct_manage.pl restoreaccount" (restore ทั้งหมดที่regisaccount ไว้) หากมีการเข้าใช้งานระหว่างช่วงเวลาที่Cron มีการรันscript อาจทำให้Contentที่แก้ไขไปสูญหายได้

3. Unregister
    * คือการนำ cpanel userนั้นออกจากระบบrestore หากใช้คำสั่งนี้ cpanel userนั้นจะไม่สามารถ restoreได้ นอกจากจะregisterเข้ามาใหม่

       ```language
        perl /usr/local/rv_demo_acct_manage/demo_acct_manage.pl unregisaccount {CPANELUSER} 
       ```

4. List account
    * คือการแสดงรายชื่อ cpanel user ที่มีการบันทึกไว้ในระบบ

       ```language
        perl /usr/local/rv_demo_acct_manage/demo_acct_manage.pl listaccount
       ```

        >NOTE!  การ setting crontab ให้แก้ไขไฟล์ที่ /etc/crontab  (ใช้ crontab -e แล้วcronทำงานไม่ถูกต้อง)
