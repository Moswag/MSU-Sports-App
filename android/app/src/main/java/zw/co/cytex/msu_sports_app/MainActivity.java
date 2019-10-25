package zw.co.cytex.msu_sports_app;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Set;
import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/print";
  protected static final String TAG = "TAG";
  private static final int REQUEST_CONNECT_DEVICE = 1;
  private static final int REQUEST_ENABLE_BT = 2;
  BluetoothAdapter mBluetoothAdapter;
  private UUID applicationUUID = UUID
          .fromString("00001101-0000-1000-8000-00805F9B34FB");
  private BluetoothSocket mBluetoothSocket;
  BluetoothDevice mBluetoothDevice;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    if (mBluetoothAdapter == null) {
      Toast.makeText(MainActivity.this, "Message1", Toast.LENGTH_SHORT).show();
    } else {
      if (!mBluetoothAdapter.isEnabled()) {
        Intent enableBtIntent = new Intent(
                BluetoothAdapter.ACTION_REQUEST_ENABLE);
        startActivityForResult(enableBtIntent,
                REQUEST_ENABLE_BT);
      } else {
        ListPairedDevices();
        String mDeviceAddress = "00:02:5B:00:45:8E";
        Log.v(TAG, "Coming incoming address " + mDeviceAddress);
        mBluetoothDevice = mBluetoothAdapter
                .getRemoteDevice(mDeviceAddress);
        run();
      }
    }


    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("printReceipt")) {
                  String branch= call.argument("branch");
                  String address= call.argument("address");
                  String mass= call.argument("mass");
                  String price= call.argument("price");
                  String amount=call.argument("amount");
                  String currency= call.argument("currency");
                  String name = call.argument("name");



                  boolean printStatus = mPrint(branch,address,mass,price,amount,currency,name);

                  if (printStatus) {
                    result.success(printStatus);
                  } else {
                    result.error("UNAVAILABLE", "Failed to print.", null);
                  }
                } else {
                  result.notImplemented();
                }
              }
            });


  }


  boolean mPrint(String branch,String address,String mass,String price,String amount,String currency,String name){
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    String date = format.format( new Date()   );

    Thread t = new Thread() {
      public void run() {
        try {
          OutputStream os = mBluetoothSocket
                  .getOutputStream();
          String BILL = "";

          BILL = "Propane Energy Gas\n"+
                  branch+"\n" +
                  address+"\n";
          BILL = BILL
                  + "--------------------------------\n";


          BILL = BILL + String.format("%1$-8s %2$8s %3$8s", "Item", "Mass",  "Total");
          BILL = BILL + "\n";
          BILL = BILL
                  + "--------------------------------";
          BILL = BILL + "\n " + String.format("%1$-8s %2$8s %3$8s", "Gas", mass+" KGs",  amount);


          BILL = BILL
                  + "\n\n--------------------------------";
          BILL = BILL + "\n\n";

          BILL = BILL + "   Per KG Price : $"+ price+ "\n";
          BILL = BILL + "   Total Mass   : " + mass+" KGs" + "\n";
          BILL = BILL + "   Total Amount : " + amount + "\n";
          BILL = BILL + "   Payment Type : " + currency + "\n";

          BILL = BILL
                  + "--------------------------------\n";
          BILL = BILL + "\n\n";
          BILL = BILL + "Sales Person: " + name+"\n";
          BILL = BILL + "Date: " + date + "\n\n\n";
          os.write(BILL.getBytes());
          //This is printer specific code you can comment ==== > Start

          // Setting height
          int gs = 29;
          os.write(intToByteArray(gs));
          int h = 104;
          os.write(intToByteArray(h));
          int n = 162;
          os.write(intToByteArray(n));

          // Setting Width
          int gs_width = 29;
          os.write(intToByteArray(gs_width));
          int w = 119;
          os.write(intToByteArray(w));
          int n_width = 2;
          os.write(intToByteArray(n_width));



        } catch (Exception e) {
          Log.e("MainActivity", "Exe ", e);
        }
      }
    };
    t.start();
    return true;

  }

  @Override
  protected void onDestroy() {
    // TODO Auto-generated method stub
    super.onDestroy();
    try {
      if (mBluetoothSocket != null)
        mBluetoothSocket.close();
    } catch (Exception e) {
      Log.e("Tag", "Exe ", e);
    }
  }

  @Override
  public void onBackPressed() {
    try {
      if (mBluetoothSocket != null)
        mBluetoothSocket.close();
    } catch (Exception e) {
      Log.e("Tag", "Exe ", e);
    }
    setResult(RESULT_CANCELED);
    finish();
  }



  private void ListPairedDevices() {
    Set<BluetoothDevice> mPairedDevices = mBluetoothAdapter
            .getBondedDevices();
    if (mPairedDevices.size() > 0) {
      for (BluetoothDevice mDevice : mPairedDevices) {
        Log.v(TAG, "PairedDevices: " + mDevice.getName() + "  "
                + mDevice.getAddress());
      }
    }
  }

  public void run() {
    try {
      mBluetoothSocket = mBluetoothDevice
              .createRfcommSocketToServiceRecord(applicationUUID);
      mBluetoothAdapter.cancelDiscovery();
      mBluetoothSocket.connect();
      mHandler.sendEmptyMessage(0);
    } catch (IOException eConnectException) {
      Log.d(TAG, "CouldNotConnectToSocket", eConnectException);
      closeSocket(mBluetoothSocket);
      return;
    }
  }

  private void closeSocket(BluetoothSocket nOpenSocket) {
    try {
      nOpenSocket.close();
      Log.d(TAG, "SocketClosed");
    } catch (IOException ex) {
      Log.d(TAG, "CouldNotCloseSocket");
    }
  }

  private Handler mHandler = new Handler() {
    @Override
    public void handleMessage(Message msg) {
      //mBluetoothConnectProgressDialog.dismiss();
      Toast.makeText(MainActivity.this, "DeviceConnected", Toast.LENGTH_SHORT).show();
    }
  };

  public static byte intToByteArray(int value) {
    byte[] b = ByteBuffer.allocate(4).putInt(value).array();

    for (int k = 0; k < b.length; k++) {
      System.out.println("Selva  [" + k + "] = " + "0x"
              + UnicodeFormatter.byteToHex(b[k]));
    }

    return b[3];
  }





}

