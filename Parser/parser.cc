#include<bits/stdc++.h>
using namespace std;

/*
Function to convert given instruction line to individual strings and storing them in a vector of strings
*/
vector<string> convertInstructionLine(string instruction_line){ 
    vector<string> instruction;
    set<char> delimiters = {' ',','};
    int i=0,j=0;
    while(j<instruction_line.length()){
        while(j<instruction_line.length() && delimiters.find(instruction_line[j]) == delimiters.end()){
            j++;
        }
        instruction.push_back(instruction_line.substr(i,j-i));
        i = j + 1;
        j++;
    }
    return instruction;
}

/*
Function to convert given instruction line to individual strings and storing them in a vector of strings
*/
string convertDecimalToBinary(string decimal_number, unsigned int bit) {
    int number = stoi(decimal_number);
    
    if (number == 0) {
        return string(bit, '0'); // Return a string of '0's if the input is 0
    }
    string binStr;
    int neg_flag=0;
    if(number<0){
        number = -1*number;
        neg_flag=1;
    }
    while (number > 0) {
        binStr = char('0' + (number % 2)) + binStr; // Append the least significant bit to the beginning of the string
        number /= 2;
    }
    if (binStr.length() < bit) {
        binStr = string(bit - binStr.length(), '0') + binStr; // Pad with '0's if necessary to achieve the desired bit length
    }
    if(neg_flag==1){
        int carry=1;
        for(int i=0;i<bit;i++){
            binStr[i] = binStr[i]=='1' ? '0' : '1';
        }
        for(int i=bit-1;i>=0;i--){
            if(binStr[i]=='0' && carry==1){
                binStr[i]='1';
                break;
            }
            else if(binStr[i]=='1' && carry==0){
                binStr[i]='1';
                break;
            }
            else if(binStr[i]=='1' && carry==1){
                binStr[i]='0';
                carry=1;
            }
            else{
                break;
            }
        }
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
        else if(instruction[0] == "bg"){ // 12. Borrow Generate
            outputfile << "00001000010"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "and"){ // 13. And
            outputfile << "00011000001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "andc"){ // 14. And with Complement
            outputfile << "01011000001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "andhi"){ // 15. And Halfword Immediate
            outputfile << "00010101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "andi"){ // 16. And Word Immediate
            outputfile << "00010100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "or"){ // 17. Or
            outputfile << "00001000001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "orc"){ // 18. Or Complement
            outputfile << "01011001001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "orhi"){ // 19. Or Halfword Immediate
            outputfile << "00000101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ori"){ // 20. Or Word Immediate
            outputfile << "00000100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "xor"){ // 21. Exclusive Or
            outputfile << "01001000001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "xorhi"){ // 22. Exclusive Or Halfword Immediate
            outputfile << "01000101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "xori"){ // 23. Exclusive Or Word Immediate
            outputfile << "01000100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "nand"){ // 24. Nand
            outputfile << "00011001001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "nor"){ // 25. Nor
            outputfile << "00001001001"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "clz"){ // 26. Count Leading Zeros
            outputfile << "01010100101"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "fsmh"){ // 27. Form Select Mask for Halfwords
            outputfile << "00110110101"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "fsm"){ // 28. Form Select Mask for Words
            outputfile << "00110110100"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ceqh"){ // 29. Compare Equal Halfword
            outputfile << "01111001000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ceqh"){ // 30. Compare Equal Halfword Immediate
            outputfile << "01111101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ceq"){ // 31. Compare Equal Word
            outputfile << "01111000000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ceq"){ // 31. Compare Equal Word
            outputfile << "01111000000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ceqi"){ // 32. Compare Equal Word Immediate
            outputfile << "01111100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "cgth"){ // 33. Compare Greater Than Halfword
            outputfile << "01001001000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "cgthi"){ // 34. Compare Greater Than Halfword Immediate
            outputfile << "01001101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "cgt"){ // 35. Compare Greater Than Word
            outputfile << "01001000000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "cgti"){ // 36. Compare Greater Than Word Immediate
            outputfile << "01001100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "clgth"){ // 37. Compare Logical Greater Than Halfword
            outputfile << "01011001000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "clgthi"){ // 38. Compare Logical Greater Than Halfword Immediate
            outputfile << "01011101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "clgt"){ // 39. Compare Logical Greater Than Word
            outputfile << "0101100000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "clgti"){ // 40. Compare Logical Greater Than Word Immediate
            outputfile << "01011100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ilh"){ // 41. Immediate Load Halfword
            outputfile << "010000011"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ilhu"){ // 42. Immediate Load Halfword Upper
            outputfile << "010000010"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "il"){ // 43. Immediate Load Word
            outputfile << "010000001"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "ila"){ // 44. Immediate Load Address
            outputfile << "0100001"<< convertDecimalToBinary(instruction[2], 18)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlh"){ // 45. Shift Left Halfword
            outputfile << "00001011111"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlhi"){ // 46. Shift Left Halfword Immediate
            outputfile << "00001111111"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shl"){ // 47. Shift Left Word
            outputfile << "00001011011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shli"){ // 48. Shift Left Word Immediate
            outputfile << "00001111011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "roth"){ // 49. Rotate Halfword
            outputfile << "00001011100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rothi"){ // 50. Rotate Halfword Immediate
            outputfile << "00001111100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rot"){ // 51. Rotate Word
            outputfile << "00001011000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "roti"){ // 52. Rotate Word Immediate
            outputfile << "00001111000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "fm"){ // 53. Floating Multiply
            outputfile << "01011000110"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "fma"){ // 54. Floating Multiply and Add
            outputfile << "1110"<< convertDecimalToBinary(instruction[1], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[4], 7) <<endl;
        }
        else if(instruction[0] == "fnms"){ // 55. Floating Negative Multiply and Subtract
            outputfile << "1101"<< convertDecimalToBinary(instruction[1], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[4], 7) <<endl;
        }
        else if(instruction[0] == "fms"){ // 56. Floating Multiply and Subtract
            outputfile << "1111"<< convertDecimalToBinary(instruction[1], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[4], 7) <<endl;
        }
        else if(instruction[0] == "mpy"){ // 57. Multiply
            outputfile << "01111000100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "mpyu"){ // 58. Multiply Unsigned
            outputfile << "01111001100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "mpyi"){ // 59. Multiply Immediate
            outputfile << "01110100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "mpyui"){ // 60. Multiply Unsigned Immediate
            outputfile << "01110101"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "mpya"){ // 61. Multiply and Add
            outputfile << "1100"<< convertDecimalToBinary(instruction[1], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[4], 7) <<endl;
        }
        else if(instruction[0] == "mpyh"){ // 62. Multiply High
            outputfile << "01111000101"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "absdb"){ // 63. Absolute Differences of Bytes
            outputfile << "00001010011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "avgb"){ // 64. Average Bytes
            outputfile << "00011010011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "sumb"){ // 65. Sum Bytes into Halfwords
            outputfile << "01001010011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "cntb"){ // 66. Count Ones in Bytes
            outputfile << "01010110100"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlqbi"){ // 67. Shift Left Quadword by Bits
            outputfile << "00111011011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlqbii"){ // 68. Shift Left Quadword by Bits Immediate
            outputfile << "00111111011"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlqby"){ // 69. Shift Left Quadword by Bytes
            outputfile << "00111011111"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlqbyi"){ // 70. Shift Left Quadword by Bytes Immediate
            outputfile << "00111111111"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "shlqbybi"){ // 71. Shift Left Quadword by Bytes from Bit Shift Count
            outputfile << "00111001111"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rotqby"){ // 72. Rotate Quadword by Bytes
            outputfile << "00111011100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rotqbyi"){ // 73. Rotate Quadword by Bytes Immediate
            outputfile << "00111111100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rotqbybi"){ // 74. Rotate Quadword by Bytes from Bit Shift Count
            outputfile << "00111001100"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rotqbi"){ // 75. Rotate Quadword by Bits
            outputfile << "00111011000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "rotqbii"){ // 76. Rotate Quadword by Bits Immediate
            outputfile << "00111111000"<< convertDecimalToBinary(instruction[3], 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "gbb"){ // 77. Gather Bits from Bytes
            outputfile << "00110110010"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "gbh"){ // 78. Gather Bits from Halfwords
            outputfile << "00110110001"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "gb"){ // 79. Gather Bits from Words
            outputfile << "00110110000"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "lqd"){ // 80. Load Quadword (d-form)
            outputfile << "00110100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "lqa"){ // 81. Load Quadword (a-form)
            outputfile << "001100001"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "stqd"){ // 82. Store Quadword (d-form)
            outputfile << "00100100"<< convertDecimalToBinary(instruction[3], 10)<< convertDecimalToBinary(instruction[2], 7)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "stqa"){ // 83. Store Quadword (a-form)
            outputfile << "001000001"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "br"){ // 84. Branch Relative
            outputfile << "001100100"<< convertDecimalToBinary(instruction[1], 16)<< convertDecimalToBinary(null_string_append, 7) <<endl;
        }
        else if(instruction[0] == "bra"){ // 85. Branch Absolute
            outputfile << "001100000"<< convertDecimalToBinary(instruction[1], 16)<< convertDecimalToBinary(null_string_append, 7) <<endl;
        }
        else if(instruction[0] == "brsl"){ // 86. Branch Relative and Set Link
            outputfile << "001100110"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "brasl"){ // 87. Branch Absolute and Set Link
            outputfile << "001100010"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "brnz"){ // 88. Branch If Not Zero Word
            outputfile << "001000010"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "brz"){ // 89. Branch If Zero Word
            outputfile << "001000000"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "brhnz"){ // 90. Branch If Not Zero Halfword
            outputfile << "001000110"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "brhz"){ // 91. Branch If Zero Halfword
            outputfile << "001000100"<< convertDecimalToBinary(instruction[2], 16)<< convertDecimalToBinary(instruction[1], 7) <<endl;
        }
        else if(instruction[0] == "stop"){ // 92. Stop and Signal
            outputfile << "00000000000"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7) <<endl;
        }
        else if(instruction[0] == "nop"){ // 93. No Operation (Execute)
            outputfile << "01000000001"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7) <<endl;
        }
        else if(instruction[0] == "lnop"){ // 94. No Operation (Load)
            outputfile << "00000000001"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7) <<endl;
        }
        else {outputfile << "00000000000"<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7)<< convertDecimalToBinary(null_string_append, 7) <<endl;}
    }
    outputfile.close();
}