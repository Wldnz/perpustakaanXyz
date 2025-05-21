/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package perpustakaan.utilities;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author Wildan
 */
public class konfigurasi {
    
    private final String base_url = "http://localhost/api-perpustakaan/";
    private String result;
    
    public JSONObject sendGetRequest(String endpoint) throws IOException, ParseException{
        JSONObject obj = new JSONObject();
        try {
            URL url = new URL(base_url + endpoint);
            HttpURLConnection koneksi = (HttpURLConnection) url.openConnection();
            koneksi.setRequestMethod("GET");
          
            if(koneksi.getResponseCode() == HttpURLConnection.HTTP_OK){
                
                BufferedReader bfr = new BufferedReader(new InputStreamReader(koneksi.getInputStream()));
                String inputLine;
                StringBuilder resp = new StringBuilder();
                
                while((inputLine = bfr.readLine()) != null){
                    resp.append(inputLine);
                }
                
                bfr.close();
                
                JSONParser parser = new JSONParser();
                obj = (JSONObject) parser.parse(resp.toString());
            }
            
        } catch (MalformedURLException ex) {
            Logger.getLogger(konfigurasi.class.getName()).log(Level.SEVERE, null, ex);
        }
        return obj;
    }
    
    public JSONObject sendPostRequest(String endpoint, HashMap<String,String> data) throws IOException, ParseException{
        JSONObject obj = new JSONObject();
        try {
            URL url = new URL(base_url + endpoint);
            HttpURLConnection koneksi = (HttpURLConnection) url.openConnection();
            koneksi.setRequestMethod("POST");
            
            koneksi.setDoOutput(true);
            OutputStream os = koneksi.getOutputStream();
            os.write(convertToParams(data).getBytes());
            os.flush();
            os.close();
            
            if(koneksi.getResponseCode() == HttpURLConnection.HTTP_OK){
                
                BufferedReader bfr = new BufferedReader(new InputStreamReader(koneksi.getInputStream()));
                String inputLine;
                StringBuilder resp = new StringBuilder();
                
                while((inputLine = bfr.readLine()) != null){
                    resp.append(inputLine);
                }
                
                bfr.close();
                
                JSONParser parser = new JSONParser();
                obj = (JSONObject) parser.parse(resp.toString());
            }
            
        } catch (MalformedURLException ex) {
            Logger.getLogger(konfigurasi.class.getName()).log(Level.SEVERE, null, ex);
        }
        return obj;
    }
    
    
    public String convertToParams(HashMap<String,String> data){
        result = "";
        data.forEach((k, v) -> {
           result += k + "='" + v + "'&";
        });
        return result;
        
    }
    
}
