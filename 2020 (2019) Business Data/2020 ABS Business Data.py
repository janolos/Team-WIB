#!/usr/bin/env python
# coding: utf-8

# ## Load Libraries

# In[14]:


import pandas as pd
import numpy as np


# ## Load Data & View Data

# In[15]:


WBiz2020 = pd.read_csv (r"C:\Users\nbroo\OneDrive\Documents\Data Science Final Group Project\Women In Business Before And After The Pandemic\2020 (2019) Census Business Data.csv")


# In[16]:


WBiz2020.head()


# ## Rename Columns

# In[19]:


WBiz2020.rename(columns={'SEX' : 'Owners_Sex', 'ETH_GROUP' : 'Owners_Ethnicity', 'RACE_GROUP' : 'Owners_Race', 'VET_GROUP' : 'Vet_Status', 'RCPPDEMP' : 'Sales', 'EMP' : 'Employees', 'RCPPDEMP_S' : 'Sales_Std_Error', 'EMP_S' : 'Employees_Std_Error'}, inplace=True)


# In[20]:


WBiz2020.head()


# ## Subset Dataset

# In[21]:


WBiz2020Sub = WBiz2020[['Owners_Sex', 'Owners_Ethnicity', 'Owners_Race', 'Vet_Status', 'Sales', 'Employees', 'Sales_Std_Error', 'Employees_Std_Error']]


# In[22]:


WBiz2020Sub.head()


# ## Recode Dataset

# ### About Dataset

# In[24]:


WBiz2020Sub.info()


# ### Change From Objects To Float

# In[26]:


WBiz2020Sub = WBiz2020Sub.apply(pd.to_numeric)
print(WBiz2020Sub.info())


# In[ ]:




