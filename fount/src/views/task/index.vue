<template>
    <div class="container">
        <div class="main-wrapper card">
            <router-view></router-view>
        </div>
    </div>
</template>

<script>
export default {
    components: {},
    props: {},
    data() {
        return {
        };
    },
    created() {
        this.keepActive();
    },
    mounted() {

    },
    watch: {},
    computed: {},
    methods: {

    }
};
</script>
<style lang="scss" scoped>
.filter-container {
    display: flex;

    .filter-label {
        color: #1b1e26;
        font-size: 14px;
        min-width: 68px;
        padding: 4px 16px 4px 0;
    }

    .filter-options {
        display: flex;
        flex-wrap: wrap;

        .option {
            border-radius: 3px;
            cursor: pointer;
            margin-bottom: 15px;
            margin-right: 5px;
            padding: 4px 16px;
            font-size: 14px;

            &.atv-option {
                color: #3852dd;
                background-color: rgba(101, 118, 200, 0.18);
            }
        }
    }
}
</style>