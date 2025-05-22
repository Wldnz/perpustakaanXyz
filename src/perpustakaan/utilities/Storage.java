/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package perpustakaan.utilities;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Wildan
 */
public class Storage {
    
    private final HashMap<String,String> storage = new HashMap<>();
    private String valueText = "";
    
    public Storage(){
         try{
        
            File file = new File("secret/storage.txt");
            if(!file.exists()){
                try {
                    file.createNewFile();
                } catch (IOException ex) {
                    Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            
            Scanner scanner = new Scanner(file);


            while(scanner.hasNextLine()){
                String[] data = scanner.nextLine().split("=");
                this.setStorage(data[0],data[1]);
            }
            
            scanner.close();
            
        }catch(FileNotFoundException e){
            e.printStackTrace();
        }
    }
    
    
    private void setStorage(String key, String value){
        this.storage.put(key, value);
    }
    
    public void setData(String key, String value) {
        FileWriter file = null;
        try {
            file = new FileWriter("secret/storage.txt");
            valueText = key + "=" + value + "\n";
            storage.forEach((k, v) -> {
                valueText += k + "=" + v + "\n";
            }); 
            file.write(valueText);
            file.close();
            this.storage.put(key, value);
        } catch (IOException ex) {
            Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void removeData(String key){
        FileWriter file = null;
        try {
            file = new FileWriter("secret/storage.txt");
            valueText = "";
            storage.forEach((k, v) -> {
                if(!k.equals(k)){
                    valueText += k + "=" + v + "\n";
                }
            }); 
            file.write(valueText);
            file.close();
            this.storage.remove(key);
        } catch (IOException ex) {
            Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    
    public HashMap<String,String> getAll(){
        return this.storage;
    }
    
    public String getDataByKey(String key){
        return this.storage.get(key);
    }
    
    public void clear(){
        FileWriter file = null;
        try {
            file = new FileWriter("secret/storage.txt");
            valueText = "";
            file.write(valueText);
            file.close();
            this.storage.clear();
        } catch (IOException ex) {
            Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
        }
        this.storage.clear();
    }
    
    
}
