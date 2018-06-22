#include <bits/stdc++.h>
using namespace std;
int main() {
    int x;
    vector<int> v;
    while (scanf("%1d", &x) != EOF) {
        v.push_back(x);
    }
    for (int i = 0; i < v.size(); i++) {
        printf("%d", v[i]);
        if ((i + 1) % 8 == 0) printf("\n");
    }
}