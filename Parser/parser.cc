#include<bits/stdc++.h>
using namespace std;

/*
Function to convert given instruction line to individual strings and storing them in a vector of strings
*/
vector<string> convertInstructionLine(string instruction_line){ 
    vector<string> instruction;
    istringstream ss(instruction_line);
    string temp_word;
    while(ss >> temp_word){
        instruction.push_back(temp_word);
    }
    return instruction;
}

/*
Function to convert given instruction line to individual strings and storing them in a vector of strings
*/
string convertDecimalToBinary(string decimal_number, unsigned int bit) {
    int number;
    istringstream(decimal_number) >> number;
    if (number == 0) {
        return std::string(bit, '0'); // Return a string of '0's if the input is 0
    }
    string binStr;
    while (number > 0) {
        binStr = char('0' + (number % 2)) + binStr; // Append the least significant bit to the beginning of the string
        number /= 2;
    }
    if (binStr.length() < bit) {
        binStr = string(bit - binStr.length(), '0') + binStr; // Pad with '0's if necessary to achieve the desired bit length
    }
    return binStr;
}

int main(){
    ifstream inputfile("Instructions.txt"); // Reading Instructions line by line from Instructions.txt
    ofstream outputfile; // Output file declaration 
    
    outputfile.open("InstructionsToBinary.txt"); // Accessing output file IntructionsToBinary.txt
    string instruction_line; // Iterator for each instruction in Instructions.txt
    string null_string_append = "000"; 

    while(getline(inputfile,instruction_line)){
        vector<string> instruction = convertInstructionLine(instruction_line); // Vector String to store individual strings in instruction_line
        
        if(instruction[0] == "a"){ // 1. Add Word
            outputfile << "00011000000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ah"){ // 2. Add Halfword
            outputfile << "00011001000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ahi"){ // 3. Add Halfword Immediate
            outputfile << "00011101"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ai"){ // 4. Add Word Immediate
            outputfile << "00011100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "sf"){ // 5. Subtract from Word
            outputfile << "00001000000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "sfh"){ // 6. Subtract from Halfword
            outputfile << "00001001000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "sfhi"){ // 7. Subtract from Halfword Immediate
            outputfile << "00001101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "sfi"){ // 8. Subtract from Word Immediate
            outputfile << "00001100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "addx"){ // 9. Add Extended
            outputfile << "01101000000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "sfx"){ // 10. Subtract from Extended
            outputfile << "01101000001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "cg"){ // 11. Carry Generate
            outputfile << "00011000010"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else {cout<< instruction[0]<<" : Instruction not Found"<<endl;}
    }
    return 0;
}