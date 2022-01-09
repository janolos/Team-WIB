#!/usr/bin/env python
# coding: utf-8

# ## Load Libraries

# In[24]:


import pandas as pd
import numpy as np


# ## Load Data & View Data

# In[25]:


WBiz2019 = pd.read_csv (r"C:\Users\nbroo\OneDrive\Documents\Data Science Final Group Project\Women In Business Before And After The Pandemic\2019 (2018) Census Business Data.csv")


# In[26]:


WBiz2019.head()


# ## Rename Columns

# In[27]:


WBiz2019.rename(columns={'SEX' : 'Owners_Sex', 'ETH_GROUP' : 'Owners_Ethnicity', 'RACE_GROUP' : 'Owners_Race', 'VET_GROUP' : 'Vet_Status', 'RCPPDEMP' : 'Sales', 'EMP' : 'Employees', 'RCPPDEMP_PCT_S' : 'Sales_Std_Error', 'EMP_S' : 'Employees_Std_Error'}, inplace=True)


# In[28]:


WBiz2019.head()


# ## Clean Dataset

# ### Drop Columns

# In[29]:


WBiz2019 = WBiz2019.drop(labels=0, axis=0)


# In[30]:


WBiz2019.head()


# ## Subset Dataset

# In[31]:


WBiz2019Sub = WBiz2019[['Owners_Sex', 'Owners_Ethnicity', 'Owners_Race', 'Vet_Status', 'Sales', 'Employees', 'Sales_Std_Error', 'Employees_Std_Error']]


# In[32]:


WBiz2019Sub.head()


# ## Recode Dataset

# ### About Dataset

# In[38]:


WBiz2019Sub.info()


# ### Change From Objects To Float

# In[37]:


WBiz2019Sub = WBiz2019Sub.apply(pd.to_numeric, errors='coerce')
print(WBiz2019Sub.info())


# In[ ]:




