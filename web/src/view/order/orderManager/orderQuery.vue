<template>
    <div>
      <div class="gva-search-box">
        <el-form ref="searchForm" :inline="true" :model="searchInfo">
          
          <el-form-item label="创建日期" prop="createdAt">
            <template #label>
              <span>
                创建日期
                <el-tooltip
                  content="搜索范围是开始日期（包含）至结束日期（不包含）"
                >
                  <el-icon><QuestionFilled /></el-icon>
                </el-tooltip>
              </span>
            </template>
            <el-date-picker
              v-model="searchInfo.sdate"
              type="datetime"
              placeholder="开始日期"
              :disabled-date="
                (time) =>
                  searchInfo.sdate
                    ? time.getTime() > searchInfo.sdate.getTime()
                    : false
              "
            ></el-date-picker>
            —
            <el-date-picker
              v-model="searchInfo.edate"
              type="datetime"
              placeholder="结束日期"
              :disabled-date="
                (time) =>
                  searchInfo.edate
                    ? time.getTime() < searchInfo.edate.getTime()
                    : false
              "
            ></el-date-picker>
          </el-form-item>          
          
          <el-form-item label="姓名">
            <el-input v-model="searchInfo.name" placeholder="姓名" />
          </el-form-item>
          <el-form-item label="账号">
            <el-input v-model="searchInfo.useraccount" placeholder="账号" />
          </el-form-item>
          <el-form-item label="订单号">
            <el-input v-model="searchInfo.orderSn" placeholder="订单号" />
          </el-form-item>

          <el-form-item label="订单类型" prop="certType">
            <el-select v-model="searchInfo.certType" placeholder="请选择订单类型" style="width: 130px">
              <el-option label="请选择" value="" />
              <el-option v-for="item in nations" :key="item.value" :label="item.label" :value="item.value" />

            </el-select>
          </el-form-item>
  
          <el-form-item>
            <el-button type="primary" icon="search" @click="onSubmit">
              查询
            </el-button>
            <el-button icon="refresh" @click="onReset"> 重置 </el-button>
          </el-form-item>
        </el-form>
      </div>
  
      <div class="gva-table-box">
  
        <el-table :data="tableData" row-key="ID">
          <el-table-column align="left" label="ID" min-width="50" prop="ID" />
          <el-table-column
            align="left"
            label="订单号"
            min-width="220"
            prop="orderSn"
          />
          
          <el-table-column
            align="left"
            label="订单名称"
            min-width="110"
            prop="body"
          />
  
          <el-table-column
            align="left"
            label="订单类型"
            min-width="100"
            prop="certType"
          />
          <el-table-column
            align="left"
            label="订单状态"
            min-width="100"
            prop="status"
          >
          <template #default="{ row }">
            {{ statusText(row.status) }}
          </template>
          </el-table-column>

          <el-table-column
            align="left"
            label="创建时间"
            min-width="180"
            prop="CreatedAt"
          >
          <template #default="{ row }">
              {{ formatDate(row.CreatedAt) }}
            </template>
          </el-table-column>
  
          <el-table-column
            align="left"
            label="支付时间"
            min-width="180"
            prop="payTime"
          >
            <template #default="{ row }">
              {{ formatDate(row.payTime) }}
            </template>
          </el-table-column>
  
          <el-table-column
            align="left"
            label="金额(元)"
            min-width="90"
            prop="totalFee"
          >
          <template #default="{ row }">
              {{ (row.totalFee / 100).toFixed(2) }}
            </template>
          
          </el-table-column>
  
          <el-table-column label="操作" :min-width="90" fixed="right">
            <template #default="scope">
              <el-button
                type="primary"
                link
                icon="magic-stick"
                @click="orderDetail(scope.row)"
                >详情</el-button
              >
            </template>
          </el-table-column>
        </el-table>
        <div class="gva-pagination">
          <el-pagination
            :current-page="page"
            :page-size="pageSize"
            :page-sizes="[10, 30, 50, 100]"
            :total="total"
            layout="total, sizes, prev, pager, next, jumper"
            @current-change="handleCurrentChange"
            @size-change="handleSizeChange"
          />
        </div>
      </div>
  
    </div>
  </template>
  
  <script setup>
    import {
      getTrainStuList,
      delTrainStuById,
      setTrainStuInfo,
      insertTrainStu
    } from '@/api/user'
  
    import { getAuthorityList } from '@/api/authority'
    import { setUserInfo, getOrderList } from '@/api/user.js'
  
    //import zhengshuInfo from '@/view/business/certificate/certificateInfo.vue'
    import { nextTick, ref, watch } from 'vue'
    import { ElMessage, ElMessageBox } from 'element-plus'
    import { useAppStore } from "@/pinia";
    import { useRouter } from 'vue-router'
    import dayjs from 'dayjs'
  
    defineOptions({
      name: 'orderQuery'
    })

    

    const appStore = useAppStore()
    const router = useRouter()
  
    const searchInfo = ref({
      name: '',
      useraccount: '',
      orderSn: '',
      certType: '',
      //status: 0,
      sdate: '',
      edate: ''
    })

    const nations = ref([
      { label: '毕业订单', value: 'graduation' },
      { label: '培训订单', value: 'training' }
    ])

    const statusText = (status) => {
      const map = {
        0: '未支付',
        1: '已支付',
        2: '已取消',
        3: '已退款'
      }
      return map[status] || '未知'
    }
    
    const onSubmit = () => {
      page.value = 1
      getTableData()
    }
  
    const onReset = () => {
      searchInfo.value = {
        name: '',
        useraccount: '',
        orderSn: '',
        certType: '',
        //status: 0,
        sdate: '',
        edate: ''
      }
      getTableData()
    }
    // 初始化相关
    const setAuthorityOptions = (AuthorityData, optionsData) => {
      AuthorityData &&
        AuthorityData.forEach((item) => {
          if (item.children && item.children.length) {
            const option = {
              authorityId: item.authorityId,
              authorityName: item.authorityName,
              children: []
            }
            setAuthorityOptions(item.children, option.children)
            optionsData.push(option)
          } else {
            const option = {
              authorityId: item.authorityId,
              authorityName: item.authorityName
            }
            optionsData.push(option)
          }
        })
    }
  
    const page = ref(1)
    const total = ref(0)
    const pageSize = ref(10)
    const tableData = ref([])
    // 分页
    const handleSizeChange = (val) => {
      pageSize.value = val
      getTableData()
    }
  
    const handleCurrentChange = (val) => {
      page.value = val
      getTableData()
    }
  
    // 查询
    const getTableData = async () => {
      const table = await getOrderList({
        page: page.value,
        pageSize: pageSize.value,
        ...searchInfo.value
      })
      if (table.code === 0) {
        tableData.value = table.data.list
        total.value = table.data.total
        page.value = table.data.page
        pageSize.value = table.data.pageSize
      }
    }
  
    watch(
      () => tableData.value,
      () => {
        setAuthorityIds()
      }
    )
  
    const initPage = async () => {
      getTableData()
      //const res = await getAuthorityList()
      //setOptions(res.data)
    }
  
    initPage()
    
    // 查询出来的表数据和页面对应上
    const setAuthorityIds = () => {
      tableData.value &&
        tableData.value.forEach((user) => {
          user.authorityIds =
            user.authorities &&
            user.authorities.map((i) => {
              return i.authorityId
            })
        })
    }
    
    // 确认重置密码
  
    const deleteUserFunc = async (row) => {
      ElMessageBox.confirm('确定要删除吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        const res = await delTrainStuById({ id: row.ID })
        if (res.code === 0) {
          ElMessage.success('删除成功')
          await getTableData()
        }
      })
    }
   
    const userForm = ref(null)

  const orderDetail = (order) =>{
      const queryParams = new URLSearchParams({
          sn:order.orderSn,
          id: order.ID
        }).toString()

        const fullPath = `#/layout/student/home/detail?${queryParams}`
        window.open(fullPath, '_blank')
    }
  
  const formatDate = (dateStr) => {
    return dateStr ? dayjs(dateStr).format('YYYY-MM-DD HH:mm:ss') : ''
  }
  
  </script>
  
  <style lang="scss">
    .header-img-box {
      @apply w-52 h-52 border border-solid border-gray-300 rounded-xl flex justify-center items-center cursor-pointer;
    }
  </style>
  