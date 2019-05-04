void print(char* msg) {

}
void printi(int n) {
}
int n = 5;
char* hmm = "hmmm";
int main() {
    int i, t1 = 0, t2 = 1, nextTerm;

    print("Fibonacci Series: ");

    for (i = 1; i <= n; ++i) {
        printi(t1);
        nextTerm = t1 + t2;
        t1 = t2;
        t2 = nextTerm;
    }
    return t1;
}