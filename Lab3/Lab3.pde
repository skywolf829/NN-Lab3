import libsvm.*;
import java.io.*;
import java.util.*;

String trainFileName = "ncrna_s.train";
String testFileName = "ncrna_s.test";
//svm_predict predictor = new svm_predict();
//svm_train trainer = new svm_train();

void start() {
  Problem2();
}
void train(String args[]) {
  try {
    svm_train.main(args);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}
void test(String args[]) {
  try {
    svm_predict.main(args);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}


void Problem1() {
  String args[];
  for (int i = -4; i <= 8; i++) {
    args = new String[] { "-t", "0", "-c", pow(2, i) + "", 
      sketchPath("") +  trainFileName, sketchPath("") + trainFileName + ".model"};
    train(args);

    args = new String[] {sketchPath("") + testFileName, 
      sketchPath("") + trainFileName + ".model", 
      sketchPath("") + "outFileProb1_" + i};
    test(args);
  }
}

void Problem2() {
  double[] accuracy = new double[169];
  //Split dataset into 5
  try {
    FileReader fileReader = new FileReader(sketchPath("") + trainFileName);
    BufferedReader bufferedReader = new BufferedReader(fileReader);
    FileWriter fileWriter1 = new FileWriter(sketchPath("") + trainFileName + ".1");
    FileWriter fileWriter2 = new FileWriter(sketchPath("") + trainFileName + ".2");
    FileWriter fileWriter3 = new FileWriter(sketchPath("") + trainFileName + ".3");
    FileWriter fileWriter4 = new FileWriter(sketchPath("") + trainFileName + ".4");
    FileWriter fileWriter5 = new FileWriter(sketchPath("") + trainFileName + ".5");
    FileWriter fileWriter6 = new FileWriter(sketchPath("") + trainFileName + ".1-test");
    FileWriter fileWriter7 = new FileWriter(sketchPath("") + trainFileName + ".2-test");
    FileWriter fileWriter8 = new FileWriter(sketchPath("") + trainFileName + ".3-test");
    FileWriter fileWriter9 = new FileWriter(sketchPath("") + trainFileName + ".4-test");
    FileWriter fileWriter10 = new FileWriter(sketchPath("") + trainFileName + ".5-test");
    FileWriter fileWriter11 = new FileWriter(sketchPath("") + trainFileName + ".0");

    BufferedWriter bufferedWriter1 = new BufferedWriter(fileWriter1);
    BufferedWriter bufferedWriter2 = new BufferedWriter(fileWriter2);
    BufferedWriter bufferedWriter3 = new BufferedWriter(fileWriter3);
    BufferedWriter bufferedWriter4 = new BufferedWriter(fileWriter4);
    BufferedWriter bufferedWriter5 = new BufferedWriter(fileWriter5);    
    BufferedWriter bufferedWriter6 = new BufferedWriter(fileWriter6);
    BufferedWriter bufferedWriter7 = new BufferedWriter(fileWriter7);
    BufferedWriter bufferedWriter8 = new BufferedWriter(fileWriter8);
    BufferedWriter bufferedWriter9 = new BufferedWriter(fileWriter9);
    BufferedWriter bufferedWriter10 = new BufferedWriter(fileWriter10); 
    BufferedWriter bufferedWriter11 = new BufferedWriter(fileWriter11);

    String line = "";
    int lineNum = 0;
    while ((line = bufferedReader.readLine()) != null) {
      if (lineNum % 10 == 0) { 
        bufferedWriter6.write(line); 
        bufferedWriter6.newLine();
      } else if (lineNum % 10 < 5) { 
        bufferedWriter1.write(line); 
        bufferedWriter1.newLine();
      }
      if (lineNum % 10 == 1) { 
        bufferedWriter7.write(line);
        bufferedWriter7.newLine();
      } else if (lineNum % 10 < 5) {
        bufferedWriter2.write(line);
        bufferedWriter2.newLine();
      }
      if (lineNum % 10 == 2) { 
        bufferedWriter8.write(line);
        bufferedWriter8.newLine();
      } else if (lineNum % 10 < 5) {
        bufferedWriter3.write(line);
        bufferedWriter3.newLine();
      }
      if (lineNum % 10 == 3) { 
        bufferedWriter9.write(line);
        bufferedWriter9.newLine();
      } else if (lineNum % 10 < 5) {
        bufferedWriter4.write(line);
        bufferedWriter4.newLine();
      }
      if (lineNum % 10 == 4) { 
        bufferedWriter10.write(line);
        bufferedWriter10.newLine();
      } else if (lineNum % 10 < 5) {
        bufferedWriter5.write(line);
        bufferedWriter5.newLine();
      }

      if (lineNum % 10 >= 5) { 
        bufferedWriter11.write(line); 
        bufferedWriter11.newLine();
      }
      lineNum++;
    }   

    // Always close files.
    bufferedReader.close();
    bufferedWriter1.close();
    bufferedWriter2.close();
    bufferedWriter3.close();
    bufferedWriter4.close();
    bufferedWriter5.close();
    bufferedWriter6.close();
    bufferedWriter7.close();
    bufferedWriter8.close();
    bufferedWriter9.close();
    bufferedWriter10.close();
    bufferedWriter11.close();

    String args[];
    for (int i = -4; i <= 8; i++) {
      for (int j = -4; j <= 8; j++) {
        double percentage = 0;
        for (int k = 1; k <=5; k++) {
          args = new String[] { "-t", "2", 
            "-c", pow(2, i) + "", 
            "-g", pow(2, j) + "", 
            sketchPath("") + trainFileName + "." + k, 
            sketchPath("") + trainFileName + ".model."+k};
          train(args);

          args = new String[]{sketchPath("") + trainFileName + "." + k + "-test", 
            sketchPath("") + trainFileName + ".model." + k, 
            sketchPath("") + "outFileProb2_" + k + "_" + i + "_" + j};
          test(args);

          FileReader results = new FileReader(sketchPath("") + 
            "outFileProb2_" + k + "_" + i + "_" + j);
          FileReader expected = new FileReader(sketchPath("") + 
            trainFileName + "." + k + "-test");
          BufferedReader resultsReader = new BufferedReader(results);
          BufferedReader expectedReader = new BufferedReader(expected);

          String resultsLine, expectedLine;
          double numCorrect = 0;
          double total = 0;
          while ((resultsLine = resultsReader.readLine()) != null) {
            expectedLine = expectedReader.readLine();
            numCorrect += expectedLine.substring(0, 1).equals(resultsLine.substring(0, 1)) 
              ? 1 : 0;
            total++;
          }
          println();
          percentage += (numCorrect / total);
          resultsReader.close();
          expectedReader.close();
        }
        percentage /= 5.0;
        println(i + " " + j + " " + " accuracy = " + percentage * 100);
        accuracy[(i + 4) * 13 + (j+4)] = percentage;
      }
    }
    double bestAccuracy = 0;
    int besti = 0, bestj = 0;
    print("[");
    for (int i = 0; i < 13; i++) {
      print("[ ");
      for (int j = 0; j < 13; j++) {
        String s = (accuracy[i * 13 + j]+ "");
        while (s.length() < 6) {
          s = s + "0";
        }
        s = s.substring(0, 6);
        print(s + " " );
        if (accuracy[i * 13 + j] > bestAccuracy) {
          bestAccuracy = accuracy[i * 13 + j];
          besti = i;
          bestj = j;
        }
      }
      println("]");
    }
    println("]");

    println("Best i=" + besti + ", best j=" + bestj);
    println("C="+(pow(2, besti) + "") + ", gamma=" + (pow(2, bestj) + ""));

    args = new String[] { "-t", "2", 
      "-c", pow(2, besti-4) + "", 
      "-g", pow(2, bestj-4) + "", 
      sketchPath("") + trainFileName, 
      sketchPath("") + trainFileName + ".model.final"};
    train(args);

    args = new String[]{sketchPath("") + testFileName, 
      sketchPath("") + trainFileName + ".model.final", 
      sketchPath("") + "outFileProb2_final"};
    test(args);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}