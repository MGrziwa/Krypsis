package org.krypsis.test.http.upload;

import org.krypsis.http.upload.HttpPostMessage;
import org.krypsis.http.upload.HttpUploader;
import org.krypsis.http.upload.Connectable;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.URISyntaxException;

/**
 * Date: 19.05.2009
 */
public class HttpUploadTest {
  private final static String URL = "http://localhost:3000/images";

  public static void main(String[] args) throws URISyntaxException, FileNotFoundException {
    HttpUploadTest uploadTest = new HttpUploadTest();
    final HttpUploader httpUploader = new HttpUploader();

    final InputStream fileStream = uploadTest.getClass().getResourceAsStream("image.jpg");

    try {
      byte[] bytes = new byte[fileStream.available()];
      fileStream.read(bytes, 0, bytes.length);

      final HttpPostMessage message = new HttpPostMessage();
      message.set("file", bytes, "image.jpg", "image/jpeg");
      message.set("kid", "0qn9T6spLdwgMeeMlMsgpaFyN2VmhajH@1245405600123");
      System.out.println(message.toString());

      final Connectable connection = new DesktopConnection(URL);
      final String response = httpUploader.upload(connection, message);
      System.out.println("response = " + response);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}
