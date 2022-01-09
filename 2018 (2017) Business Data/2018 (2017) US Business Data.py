#!/usr/bin/env python
# coding: utf-8

# ## Load Libraries

# In[2]:


import pandas as pd
import numpy as np


# ## Load Data & View Data

# In[3]:


WBiz2018 = pd.read_csv(r"C:\Users\nbroo\OneDrive\Documents\Data Science Final Group Project\Women In Business-Before, During, And After COVID-19\2018 (2017) Business Data\2018 (2017) Employment Size\2018 (2017) US Business Data.csv")


# In[4]:


WBiz2018.head()


# ## Rename Columns

# In[23]:


WBiz2018.rename(columns={'SEX' : 'Owners_Sex', 'ETH_GROUP' : 'Owners_Ethnicity', 'RACE_GROUP' : 'Owners_Race', 'VET_GROUP' : 'Vet_Status', 'RCPPDEMP' : 'Sales', 'EMP' : 'Employees', 'RCPPDEMP_PCT_S' : 'Sales_Std_Error', 'EMP_S' : 'Employees_Std_Error'}, inplace=True)


# In[24]:


WBiz2018.head()


# ## Clean Dataset

# ### Drop Columns

# In[25]:


WBiz2018 = WBiz2018.drop(labels=0, axis=0)


# In[8]:


WBiz2018.head()


# ## Subset Data

# In[10]:


WBiz2018Sub = WBiz2018[['Owners_Sex', 'Owners_Ethnicity', 'Owners_Race', 'Owners_Vet_Status', 'Sales', 'Employees', 'Sales_Std_Error', 'Employees_Std_Error']]


# In[11]:


WBiz2018Sub.head()


# ## Recode Data

# ### About Dataset

# In[21]:


WBiz2018Sub.info()


# ### Change From Objects To Float

# In[22]:


WBiz2018Sub['Owners_Sex'] = WBiz2018Sub['Owners_Sex'].astype(float, errors = 'raise') 
print(WBiz2018Sub.info())


# In[ ]:




