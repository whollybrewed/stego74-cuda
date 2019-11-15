void new_coset_table(int** r_table, int** g, int* u, int r, int row)
{
	int* c_all = (int*)malloc(n * sizeof(int));
	int* temp1 = (int*)malloc(n * sizeof(int));
	int* temp2 = (int*)malloc(n * sizeof(int));
	//for every row, entry is min. weight is the coset leader
	for(int i = 0; i < row; i++){
		int w_first=0;
		for(int j = 0; j < n; j++){
			temp2[j] = r_table[i][j];	
			if(temp2[j] == 1)
					w_first++;
		}
		for(int j = 0; j < k; j++)
			u[j] = 0;
		int x = 1, t = 0;
		//find all codeworde
		while(t < k){
			u[k - x] = u[k - x]^1;
			if (u[k - x] == 0){
				x++;
				continue;
			}
			else
				x = 1;
			t = 0;
			for(int j = 0; j < k; j++){
				if(u[j] == 1)
				t++;
			}	
			//mkc(g,c_all,u,n,k);
			int w_next = 0;
			//find other entries in the coset by substracting with codeword
			for(int j = 0; j < n; j++){
				temp1[j] = r_table[i][j]^c_all[j];
				if(temp1[j] == 1)
					w_next++;
			}
			//compare hamming weight
			if(w_next < w_first){
				for(int j = 0; j < n; j++){
					temp2[j] = temp1[j];
				}
			}
		}
		//assign coset leader
		for(int j = 0; j < n; j ++){
			r_table[i][j] = temp2[j];
		}
	}
	free(c_all);
	free(temp1);
	free(temp2);
}